// import Toastify from 'toastify-js'
import { customRef, ref } from '@vue/reactivity'

import StartToastifyInstance from 'toastify-js'
const Toastify = (await import('toastify-js')).default

export const useToastify = function (options?: StartToastifyInstance.Options) {
  const messages = ref<Record<string, string[]>>()

  const toast = customRef(() => {
    return {
      get() {
        return messages.value
      },
      set(value: Record<string, string[]>) {
        messages.value = value
        setMessages(value)
      },
    }
  })

  const setMessages = (flashes: Record<string, string[]>) => {
    Object.keys(flashes).forEach((flashType: string) => {
      flashes[flashType].reverse().forEach((message: string) => {
        Toastify({ ...options, text: message }).showToast()
      })
    })
  }

  return { toast }
}
