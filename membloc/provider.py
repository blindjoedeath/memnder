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

	def create_provider_assembly(self):
		code = """import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/provider/{1}_provider.dart';

class {0}ProviderAssembly extends Assembly{{

  @override
  void assemble(Container container) {{
    container.register<{0}ProviderInterface>(
      (c){{
        var provider = {0}Provider();
        return provider;
      }},
      defaultMode: InjectMode.singleton);
  }}

}}
			""".format(self.className, self.underName)
		self.create_file("provider_assembly", "application/assembly/provider/", code)

	def create_provider(self):
		code = """


abstract class {0}ProviderInterface{{

}}

class {0}Provider extends {0}ProviderInterface{{

}}
			""".format(self.className)
		self.create_file("provider", "application/provider/", code)


def main():
	arguments = sys.argv[1:]
	generator = BlocGenerator(arguments)
	generator.create_provider_assembly()
	generator.create_provider()



	print("Ты сэкономил кучу времени=)))")

if __name__ == '__main__':
    main()