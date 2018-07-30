---
external help file: PowerFIGlet-help.xml
Module Name: PowerFIGlet
online version:
schema: 2.0.0
---

# ConvertTo-FIGletFont

## SYNOPSIS
Short description

## SYNTAX

```
ConvertTo-FIGletFont [[-InputObject] <Object>] [-Font <String>] [-FontDirectory <String>]
 [-TerminalWidth <Int32>] [-Center] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
"I love FIGlet" | ConvertTo-FIGletFont -Font "standard"
```

## PARAMETERS

### -InputObject
The InputObject to convert to FIGlet font

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Font
The name of the font

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontDirectory
The directory to look in for fonts

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PowerFIGletFontDirectory
Accept pipeline input: False
Accept wildcard characters: False
```

### -TerminalWidth
The width of the terminal to use when centering the output (default: BufferSize width)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Host.UI.RawUI.BufferSize.Width
Accept pipeline input: False
Accept wildcard characters: False
```

### -Center
Center the output within the terminal

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mischa Boender

## RELATED LINKS
