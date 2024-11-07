import React from 'react';

interface FinishOrderButtonProps {
  orderId: number;
  onFinish: (orderId: number) => void;
}

const FinishOrderButton: React.FC<FinishOrderButtonProps> = ({ orderId, onFinish }) => {
  const handleFinishOrder = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/orders/${orderId}/finished`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        console.log(`Pedido ${orderId} finalizado com sucesso.`);
        onFinish(orderId);
      } else {
        console.error(`Erro: pedido ${orderId}`);
      }
    } catch (error) {
      console.error(`Erro: ${error}`);
    }
  };

  return (
    <button onClick={handleFinishOrder} style={{ marginLeft: '10px' }}>
      Finalizar Pedido
    </button>
  );
};

export default FinishOrderButton;
