// import Toastify from 'toastify-js'
import { computed, ref } from '@vue/reactivity'

const Toastify = (await import('toastify-js')).default

export const useToastify = function (options?: {
  duration?: number
  style?: Record<string, string>
}) {
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
        Toastify({ text: message, ...options }).showToast()
      })
    })
  }

  return { toast }
}
