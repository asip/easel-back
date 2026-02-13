// import Toastify from 'toastify-js'

const Toastify = (await import('toastify-js')).default

export function useToast() {
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

  return { setMessages }
}
