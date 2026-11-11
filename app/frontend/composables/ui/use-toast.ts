import { ref, customRef } from '@vue/reactivity'

import { useToastify } from './use-toastify'

export const useToast = () => {
  const { toast } = useToastify({
    duration: 2000,
    style: { 'border-radius': '5px' },
  })

  const messages = ref<Record<string, string[]>>()

  const toasts = customRef<Record<string, string[]> | undefined>(() => {
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
        toast.value = { text: message }
      })
    })
  }

  return { toasts }
}
