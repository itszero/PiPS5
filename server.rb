#!/usr/bin/env ruby
# frozen_string_literal: false

# rubocop:disable Metrics/BlockLength, Style/RescueModifier

require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'find'
require 'English'
require 'fileutils'

DRIVE_FOLDER = ENV['DRIVE_FOLDER'] || './test_data'
BASE_FOLDER = "#{DRIVE_FOLDER}/PS5/CREATE".freeze
ACCESS_LOCK_PATH = '/tmp/PIPS5_ACCESS_LOCK'.freeze

def get_full_path(type, game, filename)
  final_path = File.expand_path(File.join(type, game, filename), BASE_FOLDER)

  raise 'not found' unless final_path =~ /^#{File.expand_path(BASE_FOLDER)}/

  final_path
end

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end

get '/i/status' do
  has_access_lock = File.exist? ACCESS_LOCK_PATH
  drive_mounted = `findmnt --mountpoint ${drive_mounted}`.strip.size.positive?

  json({
    has_access_lock: has_access_lock,
    drive_mounted: drive_mounted
  })
end

get '/i/files' do
  files = Dir["#{BASE_FOLDER}/**/*"]
    .map { |p| p.gsub("#{BASE_FOLDER}/", '') }
    .filter { |p| p =~ %r{^(Screenshots|Video Clips)/} }
    .filter { |p| File.file? File.expand_path(p, BASE_FOLDER) }
    .map { |p| p.split('/') }
    .group_by { |p| p[1] }
    .transform_values do |game|
    media = game
      .group_by { |i| i[0] }
      .transform_values do |type|
      type.map { |i| i[2] }
    end
    unless media['Screenshots'].nil?
      media['Screenshots'] = media['Screenshots']
        .map do |f|
        {
          name: File.basename(f, File.extname(f)),
          file: f
        }
      end
    end
    unless media['Video Clips'].nil?
      media['Video Clips'] = media['Video Clips']
        .group_by { |f| File.basename(f, File.extname(f)) }
        .transform_values do |in_files|
        {
          name: File.basename(in_files[0], File.extname(in_files[0])),
          preview: in_files.select { |f| File.extname(f) == '.jpg' }.first,
          video: in_files.select { |f| File.extname(f) == '.webm' }.first
        }
      end
        .values
    end
    media
  end

  json files
end

get '/i/file' do
  headers({
    'Content-Disposition' => "attachment; filename=\"#{params[:file]}\""
  })

  begin
    path = get_full_path(params[:type], params[:game], params[:file])
    send_file path
  rescue StandardError
    status 404
    json({
      message: 'file not found'
    })
  end
end

get '/i/unlock' do
  FileUtils.touch ACCESS_LOCK_PATH rescue nil
  json({ ok: true })
end

get '/i/lock' do
  File.unlink ACCESS_LOCK_PATH rescue nil
  json({ ok: true })
end

# rubocop:enable Metrics/BlockLength, Style/RescueModifier