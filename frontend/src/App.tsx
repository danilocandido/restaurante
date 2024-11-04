import actionCable from 'actioncable';
import { useEffect, useState } from 'react';

interface OrderTypes {
  id: number,
  status: string,
  table: number
}

const App = () => {
  const cableApp = actionCable.createConsumer('ws://127.0.0.1:3000/cable');
  const [channel, setChannel] = useState<null | actionCable.Channel>(null);
  const [tasks, setTasks] = useState<OrderTypes[]>([]);

  useEffect(() => {
    const newChannel = cableApp.subscriptions.create(
      {
        channel: 'OrdersChannel',
      },
      {
        connected: () => console.log('connected'),
        disconnected: () => console.log('disconnected'),
        received: (message: OrderTypes) => {
          console.log("mensagem recebida :D");
          setTasks((prevTasks) => [...prevTasks, message]);
        },
      },
    );

    setChannel(newChannel);

    // Função de limpeza
    return () => {
      newChannel.unsubscribe(); // Desconecta o canal quando o componente é desmontado
    };
  }, []); // Mantém o array de dependências vazio

  return (
    <div>
      <h1>Lista de Tarefas</h1>
      <ul>
        {tasks.map((task, index) => (
          <li key={index}>
            id: {task.id}, Tabela: {task.table}, Status: {task.status}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;