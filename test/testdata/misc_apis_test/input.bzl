# This is here to test that built-in names can be shadowed by global names.
# (Regression test for http://b/35984389).
# buildifier: disable=module-docstring
config = "value for global config variable"

def my_rule_impl(ctx):
    _ignore = [ctx]  # @unused
    return []

def exercise_the_api():
    var1 = config_common.FeatureFlagInfo  # @unused
    var2 = platform_common.TemplateVariableInfo  # @unused
    var3 = repository_rule(
        implementation = my_rule_impl,
        doc = "This repository rule has documentation.",
    )  # @unused
    var4 = testing.ExecutionInfo({})  # @unused

exercise_the_api()

# buildifier: disable=provider-params
# buildifier: disable=unsorted-dict-items
MyInfo = provider(
    fields = {
        "foo": "Something foo-related.",
        "bar": "Something bar-related.",
    },
)

my_info = MyInfo(foo = "x", bar = "y")

# buildifier: disable=unsorted-dict-items
my_rule = rule(
    implementation = my_rule_impl,
    doc = "This rule exercises some of the build API.",
    attrs = {
        "src": attr.label(
            doc = "The source file.",
            allow_files = [".bzl"],
        ),
        "deps": attr.label_list(
            doc = """
A list of dependencies.
""",
            providers = [MyInfo],
            allow_files = False,
        ),
        "tool": attr.label(
            doc = "The location of the tool to use.",
            allow_files = True,
            default = Label("//foo/bar/baz:target"),
            cfg = "host",
            executable = True,
        ),
        "out": attr.output(
            doc = "The output file.",
            mandatory = True,
        ),
        "extra_arguments": attr.string_list(default = []),
    },
)
