<script>
  import { onMount } from 'svelte'
  import Content from './components/Content.svelte'

  let status = undefined
  let files = undefined

  async function fetchStatus() {
    const res = await fetch('/i/status')
    const data = await res.json()
    status = data
  }

  async function fetchFiles() {
    const res = await fetch('/i/files')
    const data = await res.json()
    files = data
  }

  async function fetchAll() {
    await fetchStatus()
    await fetchFiles()
  }

  async function lock() {
    await fetch('/i/lock')
    await fetchStatus()
  }

  async function unlock() {
    await fetch('/i/unlock')
    await fetchStatus()
  }

  onMount(() => {
    fetchAll()
    setInterval(fetchAll, 1000)
  })
</script>

<style>
  .container {
    width: 1024px;
    margin: 0 auto;
  }

  .menubar-container {
    position: fixed;
    top: 0;
    left: 0;
    height: 40px;
    width: 100%;
    padding: 5px;
    border-bottom: 1px solid #ccc;
    background-color: white;
  }

  .menubar {
    display: flex;
    flex-direction: row;
    align-items: center;
    height: 100%;
  }

  .title {
    font-weight: bold;
    font-size: 32px;
    padding-right: 20px;
  }

  .content {
    padding-top: 60px;
  }

  .items {
    display: flex;
    flex-direction: row-reverse;
    width: 100%;
    font-size: 24px;
  }

  .items > * {
    margin: 0 10px;
  }

  .button {
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 10px;
    transition: 100ms all;
    cursor: pointer;
  }

  .button:hover {
    color: #fff;
    background-color: #aa0000;
  }
</style>

<div class="menubar-container">
  <div class="container menubar">
    <div class="title">PiPS5</div>
    <div class="items">
      {#if status}
        {#if status.has_access_lock}
          🔓
          <button class="button" on:click={lock}>Lock</button>
        {:else}🔒 <button class="button" on:click={unlock}>Unlock</button>{/if}
      {/if}
    </div>
  </div>
</div>
<div class="content">
  <div class="container">
    {#if status}
      {#if status.drive_mounted}
        {#if files}
          <Content {files} on:refreshFiles={fetchFiles} />
        {:else}
          <h1>Loading...</h1>
        {/if}
      {:else if status.has_access_lock}
        <h1>⏳ Unlocking...</h1>
      {:else}
        <h1>🔒 Unlock the drive to continue</h1>
        This will remove the USB drive from PS5.
      {/if}
    {/if}
  </div>
</div>
