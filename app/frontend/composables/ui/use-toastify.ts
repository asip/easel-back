// import Toastify from 'toastify-js'
import { customRef, ref } from '@vue/reactivity'

import type StartToastifyInstance from 'toastify-js'

const Toastify = (await import('toastify-js')).default

export const useToastify = function (options?: StartToastifyInstance.Options) {
  const toastRef = ref<StartToastifyInstance.Options>()

  const toast = customRef<StartToastifyInstance.Options | undefined>(() => {
    return {
      get() {
        return toastRef.value
      },
      set(value: StartToastifyInstance.Options | undefined) {
        toastRef.value = value
        setMessage(value)
      },
    }
  })

  const setMessage = (value: StartToastifyInstance.Options | undefined): void => {
    if (value) Toastify({ ...options, ...value }).showToast()
  }

  return { toast }
}
