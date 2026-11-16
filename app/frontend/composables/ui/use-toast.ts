import { ref, customRef } from '@vue/reactivity'

import { useToastify } from './toastify'

export const useToast = () => {
  const { toast } = useToastify({
    duration: 2000,
    style: { 'border-radius': '5px' },
  })

  const errors = ref<Record<string, string[]>>()

  const toasts = customRef<Record<string, string[]> | undefined>(() => {
    return {
      get() {
        return errors.value
      },
      set(value: Record<string, string[]>) {
        errors.value = value
        setErrors(value)
      },
    }
  })

  const setErrors = (errors: Record<string, string[]>) => {
    Object.keys(errors).forEach((name: string) => {
      errors[name].reverse().forEach((message: string) => {
        toast.value = { text: message }
      })
    })
  }

  return { toasts }
}
