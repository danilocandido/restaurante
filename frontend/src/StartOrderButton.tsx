import React from 'react';

interface StartOrderButtonProps {
  orderId: number;
  onStartOrder: () => void;
}

const StartOrderButton: React.FC<StartOrderButtonProps> = ({ orderId, onStartOrder }) => {
  const handleStartOrder = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/orders/${orderId}/in_progress`, {
        method: 'PATCH',
      });
      if (response.ok) {
        onStartOrder();
        console.log(`Pedido ${orderId} iniciado com sucesso`);
      } else {
        console.error(`Erro: pedido ${orderId}`);
      }
    } catch (error) {
      console.error(`Erro: ${error}:`);
    }
  };

  return (
    <button onClick={handleStartOrder} style={{ marginRight: '10px' }}>
      Iniciar Pedido
    </button>
  );
};

export default StartOrderButton;
