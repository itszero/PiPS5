import svelte from 'rollup-plugin-svelte'
import { nodeResolve } from '@rollup/plugin-node-resolve'
import postcss from 'rollup-plugin-postcss'

export default {
  input: 'src/main.js',
  output: {
    file: 'public/bundle.js',
    format: 'iife',
  },
  plugins: [
    nodeResolve(),
    svelte({ emitCss: true }),
    postcss({ extract: true }),
  ],
}
