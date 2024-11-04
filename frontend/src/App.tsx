import actionCable from 'actioncable';
import { useEffect, useState } from 'react';

interface OrderTypes {
 status: string,
 table: number
}
// interface que define a tipagem de notificações

const App = () => {
 const cableApp = actionCable.createConsumer('ws://127.0.0.1:3000/cable');
 // configura conexão com o backend, utilize o host do seu backend

 const [channel, setChannel] = useState<null | actionCable.Channel>(null);
 // cria um estado para guardar a conexão com o canal socket para troca de mensagens

 useEffect(() => {
   if (channel !== null) channel.unsubscribe();
   // desconecta do socket caso ja exista uma conexao, evita que varias conexões iguais sejam criadas
   setChannel(
     cableApp.subscriptions.create(
       {
         channel: 'OrdersChannel'
         // canal que será criada a conexão
       },
       {
         received: (message: OrderTypes) => {
           // função que será executada ao receber uma mensagem via socket
           
           console.log("mensagem recebida :D");
           console.log(message);
          
         },
       },
     ),
   );
 }, []);
  return (
   <div/>
 );
}

export default App;
