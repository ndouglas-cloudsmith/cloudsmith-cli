{
  "name": "ea-workflow2",
  "description": "Flag any package with a GPL License used in production",
  "rego": "package cloudsmith\nimport rego.v1\n\ndefault match := false\n\ncopyleft := {\n    \"gpl-3.0\", \"gplv3\", \"gplv3+\", \"gpl-3.0-only\", \"gpl-3.0-or-later\",\n    \"gpl-2.0\", \"gpl-2.0-only\", \"gpl-2.0-or-later\", \"gplv2\", \"gplv2+\",\n    \"lgpl-3.0\", \"lgpl-2.1\", \"lgpl\", \n    \"agpl-3.0\", \"agpl-3.0-only\", \"agpl-3.0-or-later\", \"agpl\",\n    \"apache-1.1\", \"cpol-1.02\", \"ngpl\", \"osl-3.0\", \"qpl-1.0\", \"sleepycat\",\n    \"gnu general public license\"\n}\n\nmatch if {\n    lower_license := lower(input.v0[\"package\"].license)\n    some l in copyleft\n    contains(lower_license, l)\n}",
  "enabled": false,
  "is_terminal": false,
  "precedence": 2
}
