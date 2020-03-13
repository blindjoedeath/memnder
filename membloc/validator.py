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

	def create_validator_assembly(self):
		code = """import 'package:dioc/src/container.dart';
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/validator/{1}_validator.dart';
import 'package:memnder/application/validator/form_validator.dart';

class {0}ValidatorAssembly extends Assembly{{

  @override
  void assemble(Container container){{
    container.register<FormValidator<{0}Field>>(
      (c) => {0}Validator(),
      defaultMode: InjectMode.singleton);

  }}

}}""".format(self.className, self.underName)
		self.create_file("validator_assembly", "application/assembly/validator/", code)

	def create_validator(self):
		code = """import 'package:memnder/application/validator/form_validator.dart';

enum {0}Field{{
  field
}}

class {0}Validator extends FormValidator<{0}Field>{{

  FormValidationResponse<{0}Field> validate(Map<{0}Field, dynamic> form){{
    return FormValidationSuccess();
  }}

}}""".format(self.className)
		self.create_file("validator", "application/validator/", code)


def main():
	arguments = sys.argv[1:]
	generator = BlocGenerator(arguments)
	generator.create_validator_assembly()
	generator.create_validator()



	print("Ты сэкономил кучу времени=)))")

if __name__ == '__main__':
    main()