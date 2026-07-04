// import Toastify from 'toastify-js'
import { computed } from '@vue/reactivity'

const Toastify = (await import('toastify-js')).default

export function useToast() {
  const toast = computed({
    get() {
      return undefined
    },
    set(value: Record<string, string[]>) {
      setMessages(value)
    },
  })

  const setMessages = (flashes: Record<string, string[]>) => {
    Object.keys(flashes).forEach((flashType: string) => {
      flashes[flashType].reverse().forEach((message: string) => {
        Toastify({
          text: message,
          duration: 2000,
          style: { 'border-radius': '5px' },
        }).showToast()
      })
    })
  }

  return { toast }
}
