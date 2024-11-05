import actionCable from 'actioncable';
import { useEffect, useState } from 'react';
import StartOrderButton from './StartOrderButton';
import FinishOrderButton from './FinishOrderButton';

interface OrderTypes {
  id: number;
  status: string;
  table: number;
}

const App = () => {
  const cableApp = actionCable.createConsumer('ws://127.0.0.1:3000/cable');
  const [channel, setChannel] = useState<null | actionCable.Channel>(null);
  const [tasks, setTasks] = useState<OrderTypes[]>([]);
  const [startedOrders, setStartedOrders] = useState<OrderTypes[]>([]);

  useEffect(() => {
    const newChannel = cableApp.subscriptions.create(
      {
        channel: 'OrdersChannel',
      },
      {
        connected: () => console.log('connected'),
        disconnected: () => console.log('disconnected'),
        received: (message: OrderTypes) => {
          console.log('mensagem recebida :D');
          setTasks((prevTasks) => [...prevTasks, message]);
        },
      },
    );

    setChannel(newChannel);

    // Função de limpeza
    return () => {
      newChannel.unsubscribe();
    };
  }, []);

  const handleStartOrder = () => {
    if (tasks.length > 0) {
      const orderToStart = tasks[0];
      setStartedOrders((prevStartedOrders) => [...prevStartedOrders, orderToStart]);
      setTasks((prevTasks) => prevTasks.slice(1));
      console.log(`Iniciando pedido: ${orderToStart.id}`);
    }
  };

  const handleFinishOrder = (orderId: number) => {
    console.log(`Finalizando pedido: ${orderId}`);
    setStartedOrders((prevStartedOrders) => prevStartedOrders.filter(order => order.id !== orderId));
  };

  return (
    <div style={{ display: 'flex', height: '100vh' }}>
      {/* Coluna da esquerda */}
      <div style={{ flex: 1, padding: '20px', borderRight: '1px solid #ccc' }}>
        <h1>Lista de Tarefas</h1>
        <ul>
          {tasks.map((task, index) => (
            <li key={index}>
              id: {task.id}, Tabela: {task.table}, Status: {task.status}
            </li>
          ))}
        </ul>
      </div>

      {/* Coluna da direita */}
      <div style={{ flex: 1, padding: '20px' }}>
        <h1>Ações</h1>
        {tasks.length > 0 && (
          <StartOrderButton orderId={tasks[0].id} onStartOrder={handleStartOrder} />
        )}
        <h2>Pedidos Iniciados</h2>
        <ul>
          {startedOrders.map((order) => (
            <li key={order.id}>
              ID: {order.id}, Tabela: {order.table}, Status: {order.status}
              <FinishOrderButton orderId={order.id} onFinish={handleFinishOrder} />
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default App;
