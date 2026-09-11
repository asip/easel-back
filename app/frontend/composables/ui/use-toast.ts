import { useToastify } from './use-toastify'

export const useToast = () => {
  const { toast } = useToastify({
    duration: 2000,
    style: { 'border-radius': '5px' },
  })

  return { toast }
}
