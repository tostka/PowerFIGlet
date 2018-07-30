---
external help file: PowerFIGlet-help.xml
Module Name: PowerFIGlet
online version:
schema: 2.0.0
---

# Get-FIGletFont

## SYNOPSIS
Short description

## SYNTAX

### Font (Default)
```
Get-FIGletFont [-Font <String>] [-FontDirectory <String>] [<CommonParameters>]
```

### ListAvailable
```
Get-FIGletFont [-ListAvailable] [-FontDirectory <String>] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Get-FIGletFont -Font "standard"
```

## PARAMETERS

### -Font
The name of the font

```yaml
Type: String
Parameter Sets: Font
Aliases:

Required: False
Position: Named
Default value: Standard
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ListAvailable
List all available fonts

```yaml
Type: SwitchParameter
Parameter Sets: ListAvailable
Aliases:

Required: False
Position: Named
Default value: False
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
Accept pipeline input: True (ByPropertyName)
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
