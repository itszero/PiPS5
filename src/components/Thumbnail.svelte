<script>
  export let gameTitle, file
  import { createEventDispatcher } from 'svelte'

  const dispatch = createEventDispatcher()

  async function unlink() {
    if (file.type === 'screenshot') {
      await fetch(
        `/i/unlink?game=${encodeURIComponent(
          gameTitle
        )}&type=Screenshots&file=${encodeURIComponent(file.file)}`
      )
    } else if (file.type === 'video') {
      await fetch(
        `/i/unlink?game=${encodeURIComponent(
          gameTitle
        )}&type=Video Clips&file=${encodeURIComponent(file.preview)}`
      )
      await fetch(
        `/i/unlink?game=${encodeURIComponent(
          gameTitle
        )}&type=Video Clips&file=${encodeURIComponent(file.video)}`
      )
    }

    dispatch('refreshFiles')
  }
</script>

<style>
  .root {
    border-radius: 10px;
    width: 400px;
    margin: 20px 20px 20px 0;
    border: 1px solid #888;
    overflow: hidden;
    display: inline-block;
  }

  .thumbnail {
    width: 400px;
  }

  .metadata {
    padding: 5px;
  }

  .tags {
    padding: 10px 0;
    padding-top: 0;
  }

  .type {
    padding: 5px;
    border-radius: 10px;
    background-color: rgb(5, 150, 105);
    color: white;
  }
</style>

<div class="root">
  {#if file.type === 'screenshot'}
    <a
      href={`/i/file?game=${encodeURIComponent(gameTitle)}&type=Screenshots&file=${encodeURIComponent(file.file)}`}
      target="_blank">
      <img
        src={`/i/file?game=${encodeURIComponent(gameTitle)}&type=Screenshots&file=${encodeURIComponent(file.file)}`}
        alt={`thumbnail for ${file.name}`}
        class="thumbnail" />
    </a>
  {:else if file.type === 'video'}
    <a
      href={`/i/file?game=${encodeURIComponent(gameTitle)}&type=Video Clips&file=${encodeURIComponent(file.video)}`}
      target="_blank">
      <img
        src={`/i/file?game=${encodeURIComponent(gameTitle)}&type=Video Clips&file=${encodeURIComponent(file.preview)}`}
        class="thumbnail"
        alt={`thumbnail for ${file.name}`} />
    </a>
  {/if}
  <div class="metadata">
    <div class="tags">
      {#if file.type === 'screenshot'}
        <span class="type">Screenshot</span>
      {:else if file.type === 'video'}<span class="type">Video Clip</span>{/if}
    </div>
    <div>{file.name}</div>
    <button class="button" on:click={unlink}>Delete</button>
  </div>
</div>
