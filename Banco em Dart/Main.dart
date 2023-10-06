
import 'Conta.dart';
import 'Titular.dart';

void main() {
  Titular titular1 = Titular("1", "João", "123456789", "Rua A");
  Conta conta1 = Conta("1", titular1, 1000.0);

  Conta conta2 = Conta("2", Titular("2", "Maria", "987654321", "Rua B"), 500.0);

  print(conta1.toString());
  print(conta2.toString());

  conta1.depositar(200.0);
  print("Saldo após depósito: ${conta1.saldo}");

  conta1.transferir(conta2, 300.0);
  print("Saldo após transferência de conta1 para conta2: ${conta1.saldo}");
  print("Saldo da conta2 após transferência: ${conta2.saldo}");
}