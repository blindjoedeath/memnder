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

	def create_service_assembly(self):
		code = """import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/service/{1}_service.dart';

class {0}ServiceAssembly extends Assembly{{

  @override
  void assemble(Container container) {{
    container.register<{0}ServiceInterface>(
      (c){{
        var service = {0}Service();
        return service;
      }},
      defaultMode: InjectMode.singleton);
  }}

}}
			""".format(self.className, self.underName)
		self.create_file("service_assembly", "application/assembly/service/", code)

	def create_service(self):
		code = """


abstract class {0}ServiceInterface{{

}}

class {0}Service extends {0}ServiceInterface{{

}}
			""".format(self.className)
		self.create_file("service", "application/service/", code)


def main():
	arguments = sys.argv[1:]
	generator = BlocGenerator(arguments)
	generator.create_service_assembly()
	generator.create_service()



	print("Ты сэкономил кучу времени=)))")

if __name__ == '__main__':
    main()