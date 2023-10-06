class Titular {
  String id;
  String nome;
  String telefone;
  String endereco;

  Titular(this.id, this.nome, this.telefone, this.endereco);

  @override
  String toString() {
    return "Nome: $nome, Telefone: $telefone, Endereço: $endereco";
  }
}