; Class definitions, e.g. `class Foo`
(class
    "class" @context
    name: (_) @name) @item

; Singleton class definitions `class << self`
(singleton_class
    "class" @context
    "<<" @context
    value: (self) @context
) @item

; Method definition with a modifier, e.g. `private def foo`
(body_statement
    (call
        method: (identifier) @context
        arguments: (argument_list
            (method
                "def" @context
                name: (_) @name)
            )) @item
)

; Method definition without modieifer, e.g. `def foo`
(body_statement
    (method
        "def" @context
        name: (_) @name) @item
)

; Root method definition with modifier, e.g. `private def foo`
(program
    (call
        method: (identifier) @context
        arguments: (argument_list
            (method
                "def" @context
                name: (_) @name)
            )) @item
)

; Root method definition without modifier, e.g. `def foo`
(program
    (method
        "def" @context
        name: (_) @name) @item
)

; Root singleton method definition, e.g. `def self.foo`
(program
    (singleton_method
        "def" @context
        object: (_) @context
        "." @context
        name: (_) @name) @item
)

; Singleton method definition without modifier, e.g. `def self.foo`
(body_statement
    (singleton_method
        "def" @context
        object: (_) @context
        "." @context
        name: (_) @name) @item
)

; Singleton method definition with modifier, e.g. `private_class_method def self.foo`
(body_statement
    (call
        method: (identifier) @context
        arguments: (argument_list
            (singleton_method
                "def" @context
                object: (_) @context
                "." @context
                name: (_) @name) @item
            )) @item
)

; Module definition, e.g. `module Foo`
(module
    "module" @context
    name: (_) @name) @item

; Constant assignment
(assignment left: (constant) @name) @item

; Class macros such as `alias_method`, `include`, `belongs_to`, `has_many`, `attr_reader`
(class
    (body_statement
        (call
            method: (identifier) @name
            arguments: (argument_list . [
                    (string) @name
                    (simple_symbol) @name
                    (scope_resolution) @name
                    (constant) @name
                    "," @context
                ]* [
                    (string) @name
                    (simple_symbol) @name
                    (scope_resolution) @name
                    (constant) @name
                ]
            )
        ) @item
    )
)

; Module macros such as `alias_method`, `include`
(module
    (body_statement
        (call
            method: (identifier) @name
            arguments: (argument_list . [
                    (string) @name
                    (simple_symbol) @name
                    (scope_resolution) @name
                    (constant) @name
                    "," @context
                ]* [
                    (string) @name
                    (simple_symbol) @name
                    (scope_resolution) @name
                    (constant) @name
                ]
            )
        ) @item
    )
)

; Class macros without arguments, such as `private`
(class
    (body_statement
        (identifier) @name @item
    )
)

(class
    (body_statement
        (call
            method: (identifier) @name
            !arguments
        ) @item
    )
)

; Module macros without arguments, such as `private`
(module
    (body_statement
        (identifier) @name @item
    )
)

(module
    (body_statement
        (call
            method: (identifier) @name
            !arguments
        ) @item
    )
)

; Test methods
(call
    method: (identifier) @run @name (#any-of? @run "describe" "context" "test" "it")
    arguments: (argument_list . [
            (string) @name
            (simple_symbol) @name
            (scope_resolution) @name
            (constant) @name
            "," @context
        ]* [
            (string) @name
            (simple_symbol) @name
            (scope_resolution) @name
            (constant) @name
        ]
    )?
) @item
