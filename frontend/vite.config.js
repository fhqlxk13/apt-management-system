import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],

  server: {
    port: 7777,
    host: true,

    proxy: {

      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },

      '/member': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },

      '/apt': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },

      '/file': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },

      '/login.do': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },

      '/logout.do': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})