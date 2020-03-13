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

	def create_mapper_assembly(self):
		code = """import 'package:dioc/dioc.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/mapper/{1}_mapper.dart';
import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/{1}_model.dart';
import 'package:memnder/application/view_model/{1}_view_model.dart';

class {0}MapperAssembly extends Assembly{{

  @override
  void assemble(Container container) {{
    container.register<Mapper<{0}Model, {0}ViewModel>>(
      (c) => {0}Mapper(),
      defaultMode: InjectMode.singleton);

  }}

}}""".format(self.className, self.underName)
		self.create_file("mapper_assembly", "application/assembly/mapper/", code)

	def create_mapper(self):
		code = """import 'package:memnder/application/mapper/mapper.dart';
import 'package:memnder/application/model/{1}_model.dart';
import 'package:memnder/application/view_model/{1}_view_model.dart';

class {0}Mapper extends Mapper<{0}Model, {0}ViewModel>{{

}}""".format(self.className, self.underName)
		self.create_file("mapper", "application/mapper/", code)

	def create_model(self):
		code = """import 'package:flutter/material.dart';

class {0}Model{{

  const {0}Model(
  );
}}""".format(self.className, self.underName)
		self.create_file("model", "application/model/", code)

	def create_view_model(self):
		code = """import 'package:flutter/material.dart';

class {0}ViewModel{{

  const {0}ViewModel(
  );
}}""".format(self.className, self.underName)
		self.create_file("view_model", "application/view_model/", code)


def main():
	arguments = sys.argv[1:]
	generator = BlocGenerator(arguments)
	generator.create_mapper_assembly()
	generator.create_mapper()
	generator.create_model()
	generator.create_view_model()


	print("Ты сэкономил кучу времени=)))")

if __name__ == '__main__':
    main()