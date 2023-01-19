import { constants } from 'fs';
import Axios, { AxiosResponse } from 'axios'
import { ref, reactive} from 'vue/dist/vue.esm-bundler.js'
import { useViewData } from './use_view_data';

export interface User {
  id: string,
  token: string
}

export function useAccount() {
  let account: any = null;
  const logged_in: any = ref<Boolean>(false);
  const current_user: any = reactive<User>({
    id: '',
    token: ''
  })

  const { constants } = useViewData();

  const getAccount = async () => {
    const res: AxiosResponse<any, any> = await Axios.get(`${constants.api_origin}/account`,
      {
        headers: {
          Authorization: `Bearer ${current_user.token}`
        }
      })
    if (res.data) {
      account = res.data.data;
      //console.log(this.account);
      if(account){
        current_user.id = account.attributes.id;
      }
    }
  };

  return {
    account,
    logged_in,
    current_user,
    getAccount
  }
}