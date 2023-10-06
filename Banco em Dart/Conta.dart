import 'Titular.dart';

class Conta {
  String id;
  Titular titular;
  double saldo;

  Conta(this.id, this.titular, this.saldo);

  void setId(String id) {
    this.id = id;
  }

  String getId() {
    return id;
  }

  @override
  String toString() {
    return "Titular: ${titular.toString()}  Saldo: $saldo";
  }

  void depositar(double valor) {
    saldo += valor;
  }

  bool sacar(double valor) {
    if (valor <= saldo) {
      saldo -= valor;
      return true;
    } else {
      print("Saldo Insuficiente");
      return false;
    }
  }

  void transferir(Conta destino, double valor) {
    if (sacar(valor)) {
      destino.depositar(valor);
      print("Transferência realizada");
    } else {
      print("Transferência não realizada");
    }
  }
}



