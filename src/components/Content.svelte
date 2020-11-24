<script>
  import Game from './Game.svelte'

  export let files

  $: entries = Object.entries(files)
</script>

{#each entries as [title, media] (title)}
  <Game {title} {media} />
{/each}
