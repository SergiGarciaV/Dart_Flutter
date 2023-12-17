import 'package:flutter/material.dart';

// Arranca la aplicación y llama al método MyApp()
void main() {
  runApp(MyApp());
}

// Se ejecuta MyApp (widget sin estado), donde se especifica la config de la apariencia y
// tema de la app MaterialApp(). Se llama al método ListaTareasPage()
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListaTareasPage(),
    );
  }
}

// Se ejecuta este método como Widget con estado, y se llama al método _ListaTareasPageState()
class ListaTareasPage extends StatefulWidget {
  @override
  _ListaTareasPageState createState() => _ListaTareasPageState();
}

class _ListaTareasPageState extends State<ListaTareasPage> {
  // Definimos un mapa en lugar de una lista para poder manejar la creación de tareas y
  // la propiedad de tarea importante o no.
  Map<String, bool> tareas = {};

  // Definimos 2 variables booleanas que controlarán el comportamiento de los botones de
  // "eliminar" y "marcar importante"
  bool modoEliminacion = false;
  bool modoImportante = false;

  // FUNCIONES PARA GESTIONAR LAS TAREAS:

  // Agregamos la tarea que recibe como parámetro al mapa nombreTarea
  void _agregarTarea(String nombreTarea) {
    setState(() {
      tareas[nombreTarea] = false;
    });
  }

  // Eliminamos la tarea que recibimos como parámetro del mapa nombreTarea
  void _eliminarTarea(String nombreTarea) {
    setState(() {
      tareas.remove(nombreTarea);
    });
  }

  // Modificamos el 2º parámetro(bool) de la tarea, como true para manejarla como importante.
  void _marcarTareaImportante(String nombreTarea) {
    setState(() {
      tareas[nombreTarea] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 'Envolvemos' al Scaffold con un GestureDetector() que al click en cualquier lugar
    // de la pantalla cambia el state cerrando el "modo eliminación" o el "modo importante"
    return GestureDetector(
      onTap: () {
        setState(() {
          modoEliminacion = false;
          modoImportante = false;
        });
      },

      // Marco básico de la interfaz de nuestra App.
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mis Tareas'),
        ),

        // Construimos la lista de tareas
        body: ListView.builder(
          // Especificamos el nº de elementos = nº de elementos del mapa tareas.
          itemCount: tareas.length,
          // Definirá cómo se construye cada elemento de la lista según su índice.
          itemBuilder: (context, index) {
            String tareaNombre = tareas.keys.elementAt(index);
            bool esImportante = tareas[tareaNombre]!;

            // Devuelve una columna que contiene el ListTile con una fila por cada tarea
            // (en rojo en caso de ser importante) y un Divider debajo de cada tarea.
            return Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          tareaNombre,
                          style: TextStyle(
                            color: esImportante ? Colors.redAccent : null,
                          ),
                        ),
                      ),
                      if (modoEliminacion)
                        GestureDetector(
                          onTap: () {
                            _eliminarTarea(tareaNombre);
                            setState(() {
                              modoEliminacion = false;
                            });
                          },
                          child: Icon(Icons.delete_outline),
                        ),
                      if (modoImportante)
                        GestureDetector(
                          onTap: () {
                            _marcarTareaImportante(tareaNombre);
                            setState(() {
                              modoImportante = false;
                            });
                          },
                          child: Icon(Icons.outlined_flag),
                        ),
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
        // Definimos los botones
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _mostrarDialogoNuevaTarea,
              tooltip: 'Agregar Tarea',
              child: Icon(Icons.add),
            ),
            SizedBox(height: 16),

            FloatingActionButton(
              onPressed: () {
                setState(() {
                  modoEliminacion = !modoEliminacion;
                  modoImportante = false;
                });
              },
              tooltip: 'Eliminar Tarea',
              child: Icon(Icons.delete_outline),
            ),
            SizedBox(height: 16),

            FloatingActionButton(
              onPressed: () {
                setState(() {
                  modoImportante = !modoImportante;
                  modoEliminacion = false;
                });
              },
              tooltip: 'Tarea importante',
              child: Icon(Icons.outlined_flag),
            ),
          ],
        ),
      ),
    );
  }

  // Definimos el cuadro de diálogo para crear una nueva tarea
  void _mostrarDialogoNuevaTarea() {
    String nuevaTarea = '';
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar nueva tarea'),
          content: TextField(
            onChanged: (value) {
              nuevaTarea = value;
            },
            decoration:
            InputDecoration(hintText: 'Escribe el nombre de la tarea'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Agregar'),
              onPressed: () {
                if (nuevaTarea.isNotEmpty) {
                  _agregarTarea(nuevaTarea);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}