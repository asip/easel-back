// import Toastify from 'toastify-js'
import { ref, computed } from '@vue/reactivity'

const Toastify = (await import('toastify-js')).default

export function useToast() {
  const messages = ref<Record<string, string[]>>()

  const toast = computed({
    get() {
      return messages.value
    },
    set(value: Record<string, string[]>) {
      messages.value = value
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
