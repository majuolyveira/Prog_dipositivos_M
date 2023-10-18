import 'dart:io';

class Pizza {
  int codigo;
  String sabor;
  double preco;

  Pizza(this.codigo, this.sabor, this.preco);

  @override
  String toString() {
    return 'Código: $codigo, Sabor: $sabor, Preço: R\$ $preco';
  }
}

class Pedido {
  int codigo;
  DateTime data;
  List<Pizza> pizzas;
  double valorTotal;

  Pedido(this.codigo, this.data, this.pizzas, this.valorTotal);
}

void salvarDadosEmArquivo(List<Pizza> cardapio, List<Pedido> pedidos) {
  final file = File('dados.txt');
  final sink = file.openWrite();

  for (var pizza in cardapio) {
    sink.write('Pizza:${pizza.codigo},${pizza.sabor},${pizza.preco}\n');
  }

  for (var pedido in pedidos) {
    sink.write('Pedido:${pedido.codigo},${pedido.data},${pedido.valorTotal}');
    for (var pizza in pedido.pizzas) {
      sink.write(',${pizza.codigo}');
    }
    sink.write('\n');
  }

  sink.close();
}

void carregarDadosDoArquivo(List<Pizza> cardapio, List<Pedido> pedidos) {
  final file = File('dados.txt');
  if (file.existsSync()) {
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final parts = line.split(',');
      if (parts[0] == 'Pizza') {
        final codigo = int.parse(parts[1]);
        final sabor = parts[2];
        final preco = double.parse(parts[3]);
        cardapio.add(Pizza(codigo, sabor, preco));
      } else if (parts[0] == 'Pedido') {
        final codigo = int.parse(parts[1]);
        final data = DateTime.parse(parts[2]);
        final valorTotal = double.parse(parts[3]);
        final pizzaCodigos = parts.sublist(4).map((codigo) => int.parse(codigo)).toList();
        final pizzas = cardapio.where((pizza) => pizzaCodigos.contains(pizza.codigo)).toList();
        pedidos.add(Pedido(codigo, data, pizzas, valorTotal));
      }
    }
  }
}


void main() {
  List<Pizza> cardapio = [];
  List<Pedido> pedidos = [];
  int proximoCodigoPedido = 1;

  carregarDadosDoArquivo(cardapio, pedidos); // Carregar dados do arquivo ao iniciar o programa

  while (true) {
    print("\nMenu de opções:");
    print("1) Cadastrar pizza");
    print("2) Editar pizza");
    print("3) Remover pizza");
    print("4) Fazer Pedido");
    print("5) Listar Pizzas");
    print("6) Listar pedidos");
    print("7) Sair");

    stdout.write("Digite a opção desejada: ");
    var opcao = int.parse(stdin.readLineSync()!);
    if (opcao == 1) {
      stdout.write("Digite o código da pizza: ");
      var codigoPizza = int.parse(stdin.readLineSync()!);

      if (cardapio.any((pizza) => pizza.codigo == codigoPizza)) {
        print(
            "Já existe uma pizza com este código. Código duplicado não é permitido.");
      } else {
        stdout.write("Digite o sabor da pizza: ");
        var saborPizza = stdin.readLineSync()!;
        stdout.write("Digite o preço da pizza: ");
        var precoPizza = double.parse(stdin.readLineSync()!);

        var novaPizza = Pizza(codigoPizza, saborPizza, precoPizza);
        cardapio.add(novaPizza);

        print("Pizza cadastrada com sucesso!");
      }
    } else if (opcao == 2) {
      print("\nEditar pizza:");
      if (cardapio.isEmpty) {
        print("Não há pizzas cadastradas.");
      } else {
        print("Pizzas no cardápio:");
        for (var i = 0; i < cardapio.length; i++) {
          print("${i + 1}) ${cardapio[i]}");
        }

        stdout.write("Digite o código da pizza que deseja editar: ");
        var codigoEditar = int.parse(stdin.readLineSync()!);

        var pizzaEditarIndex =
            cardapio.indexWhere((pizza) => pizza.codigo == codigoEditar);

        if (pizzaEditarIndex != -1) {
          var pizzaEditar = cardapio[pizzaEditarIndex];
          print("Pizza encontrada: ${pizzaEditar}");
          stdout.write(
              "Digite o novo sabor da pizza (ou deixe em branco para manter o mesmo): ");
          var novoSabor = stdin.readLineSync()!;
          if (novoSabor.isNotEmpty) {
            pizzaEditar.sabor = novoSabor;
          }

          stdout.write(
              "Digite o novo preço da pizza (ou deixe em branco para manter o mesmo): ");
          var novoPreco = stdin.readLineSync()!;
          if (novoPreco.isNotEmpty) {
            pizzaEditar.preco = double.parse(novoPreco);
          }

          print("Pizza editada com sucesso!");
        } else {
          print("Código de pizza inválido. Tente novamente.");
        }
      }
    } else if (opcao == 3) {
      print("\nRemover pizza:");
      if (cardapio.isEmpty) {
        print("Não há pizzas cadastradas.");
      } else {
        print("Pizzas no cardápio:");
        for (var i = 0; i < cardapio.length; i++) {
          print("${i + 1}) ${cardapio[i]}");
        }

        stdout.write("Digite o código da pizza que deseja remover: ");
        var codigoRemover = int.parse(stdin.readLineSync()!);

        var pizzaRemover =
            cardapio.indexWhere((pizza) => pizza.codigo == codigoRemover);

        if (pizzaRemover != -1) {
          cardapio.removeAt(pizzaRemover);
          print("Pizza removida com sucesso!");
        } else {
          print("Código de pizza não encontrado.");
        }
      }
    } else if (opcao == 4) {
      // Fazer pedido
      if (cardapio.isEmpty) {
        print("Não há pizzas cadastradas.");
      } else {
        print("\nPizzas no cardápio:");
        for (var i = 0; i < cardapio.length; i++) {
          print("${i + 1}) ${cardapio[i]}");
        }

        print(
            "\nDigite os códigos das pizzas que deseja incluir no pedido (0 para encerrar o pedido):");
        var totalPedido = 0.0;
        var pizzaEncontrada = false;
        var pedidoAtual = <Pizza>[]; // Lista para rastrear o pedido atual

        while (true) {
          stdout.write("Código da pizza (0 para encerrar): ");
          var codigoPedido = int.parse(stdin.readLineSync()!);

          if (codigoPedido == 0) {
            break;
          }

          for (var pizza in cardapio) {
            if (pizza.codigo == codigoPedido) {
              pedidoAtual.add(pizza);
              totalPedido += pizza.preco;
              print("${pizza.sabor} adicionada ao pedido.");
              pizzaEncontrada = true;
              break;
            }
          }

          if (!pizzaEncontrada) {
            print("Código de pizza inválido. Tente novamente.");
          }
          pizzaEncontrada = false;
        }

        if (pedidoAtual.isNotEmpty) {
          var dataPedido = DateTime.now();
          var novoPedido =
              Pedido(proximoCodigoPedido, dataPedido, pedidoAtual, totalPedido);
          pedidos.add(novoPedido); // Adicionar o pedido à lista de pedidos
          proximoCodigoPedido++; // Incrementar o próximo código disponível
          print("\nPedido realizado com sucesso!");
        } else {
          print("Pedido vazio.");
        }
      }

// ...
    } else if (opcao == 5) {
      print("\nPizzas no cardápio:");
      for (var i = 0; i < cardapio.length; i++) {
        print("${i + 1}) ${cardapio[i]}");
      }
    } else if (opcao == 6) {
      // Listar pedidos
      if (pedidos.isEmpty) {
        print("Não há pedidos realizados.");
      } else {
        print("\nPedidos realizados:");

        for (var pedido in pedidos) {
          print("Código do Pedido: ${pedido.codigo}");
          print("Data do Pedido: ${pedido.data}");
          print("Pizzas:");
          for (var pizza in pedido.pizzas) {
            print(" - ${pizza.sabor}");
          }
          print("Valor Total do Pedido: R\$ ${pedido.valorTotal}");
          print("");
        }
      }
    } else if (opcao == 7) {
      salvarDadosEmArquivo(cardapio, pedidos);
      break;
    } else {
      print("Opção inválida. Tente novamente.");
    }
  }
}
