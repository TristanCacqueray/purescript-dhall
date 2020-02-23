# purescript-dhall : schemas editor with auto completion

> Note: this is currently a purescript learning exercise

The goal is to take a dhall schemas as an input, and provides
a graphical user interface to help with object creation.

The interface is recursive and composed of:
- html form input for required attribute,
- toggleable nested interface for optional attribute.

Ideally, this project would become a complete dhall binding,
though only a subset of the gramar is required:

```dhall
{ AttrLiteral : Optional AttrType
, AttrLiteralRef : ../types/Name.dhall
, AttrRecord : { NestedAttr : DhallExpr }
}
```

When the references ends in `.Type` or contains `../types/`,
the `Type::` notation is used for the resulting form.
