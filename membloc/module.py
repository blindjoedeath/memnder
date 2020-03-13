import sys
import os
import functools 

class BlocGenerator:
	def __init__(self, arguments):
		self.varName = functools.reduce(lambda a, b : a+b.capitalize(), arguments[1:], arguments[0])
		self.className = functools.reduce(lambda a, b : a+b.capitalize(), arguments, "")
		self.underName = str.join("_", arguments)
		self.folder = os.getcwd() + "/lib/"
		if not os.path.isdir(self.folder):
			os.mkdir(self.folder)

	def create_file(self, addition, subFolder, text):
		if not os.path.isdir(self.folder + subFolder):
			os.mkdir(self.folder + subFolder)
		fileName = os.path.join(self.folder + subFolder, self.underName + "_" + addition + ".dart")
		print("Created: " + fileName)
		with open(fileName, "w+") as f:
			f.write(text)

	def create_event(self):
		code = """import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class {0}Event extends Equatable {{
  const {0}Event();

  @override
  List<Object> get props => [];

}}
			""".format(self.className)
		self.create_file("event", "application/bloc/{0}/".format(self.underName), code)

	def create_state(self):
		code = """import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class {0}State extends Equatable {{
  const {0}State();

  @override
  List<Object> get props => [];

}}
			""".format(self.className)
		self.create_file("state", "application/bloc/{0}/".format(self.underName), code)

	def create_bloc(self):
		code = """import '{0}_event.dart';
import '{0}_state.dart';
import 'package:bloc/bloc.dart';

class {1}Bloc extends Bloc<{1}Event, {1}State>{{

  {1}State get initialState => null;

  @override
  Stream<{1}State> mapEventToState({1}Event event) async* {{
  }}

}}
			""".format(self.underName, self.className)
		self.create_file("bloc", "application/bloc/{0}/".format(self.underName), code)

	def create_assembly(self):
		code = """import 'package:dioc/src/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/bloc/{0}/{0}_bloc.dart';
import 'package:memnder/application/bloc/{0}/{0}_event.dart';
import 'package:memnder/application/bloc/{0}/{0}_state.dart';
import 'package:memnder/application/view/{0}/{0}_view.dart';
import 'package:memnder/application/extension/dioc//dioc_widget.dart';

class {1}Assembly extends ModuleAssembly<{1}View>{{

  Bloc<{1}Event, {1}State> _{2}Bloc;

  @override
  void assemble(Container container) {{
    container.register<Bloc<{1}Event, {1}State>>((c){{
      return {1}Bloc(
      );
    }});

    container.registerBuilder<{1}View>((context, c){{
      _{2}Bloc?.close();
      return {1}View(
        bloc: _{2}Bloc = c.create(),
      );
    }});
  }}

  @override 
  void unload(Container container) {{
    _{2}Bloc.close();
  }}

}}
			""".format(self.underName, self.className, self.varName)
		self.create_file("assembly", "application/assembly/module/", code)

	def create_view(self):
		code = """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memnder/application/bloc/{0}/{0}_event.dart';
import 'package:memnder/application/bloc/{0}/{0}_state.dart';


class {1}View extends StatefulWidget{{

  final Bloc<{1}Event, {1}State> bloc;

  const {1}View(
    {{
      @required this.bloc
    }}
  );

  @override
  State<StatefulWidget> createState() => _{1}ViewState();

}}

class _{1}ViewState extends State<{1}View>{{

  @override
  Widget build(BuildContext context) {{
    return Container();
  }}

}}
			""".format(self.underName, self.className, self.varName)
		self.create_file("view", "application/view/{0}/".format(self.underName), code)


def main():
	arguments = sys.argv[1:]
	generator = BlocGenerator(arguments)
	generator.create_event()
	generator.create_state()
	generator.create_bloc()
	generator.create_assembly()
	generator.create_view()



	print("Ты сэкономил кучу времени=)))")

if __name__ == '__main__':
    main()