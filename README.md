# MVC Gtk3 Example

## Description

This is a simple file copier. It got 3 buttons:

1. `Choose source`: Select a file to copy from
2. `Choose destination`: Select a file to write to
3. `Do it`: Perform copy 

## Implementation

1. Controller emits `ISrc` when an source file is selected. The model yields `OSrc` when it gets `ISrc`
2. Controller emits `IDest` when an destination file is selected. The model yields `ODest` when it gets `IDest`
3. Controller emits `IDoIt` when `Do It` button is clicked. The model yields `ODoIt` when it gets `IDoIt`
