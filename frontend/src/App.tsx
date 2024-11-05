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
  const [orders, setOrders] = useState<OrderTypes[]>([]);
  const [startedOrders, setStartedOrders] = useState<OrderTypes[]>([]);

  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const response = await fetch('http://127.0.0.1:3000/api/orders');
        const data = await response.json();
        // Filtra pedidos com status 'received' para tasks e outros para startedOrders
        setOrders(data.filter((order: OrderTypes) => order.status === 'waiting'));
        setStartedOrders(data.filter((order: OrderTypes) => order.status === 'in_progress'));
      } catch (error) {
        console.error('Erro ao carregar pedidos:', error);
      }
    };

    fetchOrders();

    // Subscrição ao canal de pedidos com Action Cable
    const newChannel = cableApp.subscriptions.create(
      {
        channel: 'OrdersChannel',
      },
      {
        connected: () => console.log('connected'),
        disconnected: () => console.log('disconnected'),
        received: (message: OrderTypes) => {
          console.log('mensagem recebida :D');
          setOrders((currentOrders) => [...currentOrders, message]);
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
    if (orders.length > 0) {
      const orderToStart = orders[0];
      setStartedOrders((prevStartedOrders) => [...prevStartedOrders, orderToStart]);
      setOrders((currentOrders) => currentOrders.slice(1));
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
          {orders.map((order, index) => (
            <li key={index}>
              id: {order.id}, Tabela: {order.table}, Status: {order.status}
            </li>
          ))}
        </ul>
      </div>

      {/* Coluna da direita */}
      <div style={{ flex: 1, padding: '20px' }}>
        <h1>Ações</h1>
        {orders.length > 0 && (
          <StartOrderButton orderId={orders[0].id} onStartOrder={handleStartOrder} />
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
