<script>
  import Thumbnail from './Thumbnail.svelte'
  export let title, media

  $: allMedia = [
    ...(media['Screenshots'] || []).map((file) => ({
      type: 'screenshot',
      ...file,
    })),
    ...(media['Video Clips'] || []).map((file) => ({
      type: 'video',
      ...file,
    })),
  ]
</script>

<style>
  .root {
    margin-bottom: 10px;
  }

  h1 {
    border-bottom: 1px solid #ccc;
    padding-bottom: 5px;
    margin-bottom: 5px;
  }
</style>

<div class="root">
  {#if allMedia.length > 0}
    <h1>{title.replace('_', '')}</h1>

    {#each allMedia as file}
      <Thumbnail gameTitle={title} {file} on:refreshFiles />
    {/each}
  {:else}
    <h1>No media found on the drive</h1>
  {/if}
</div>
