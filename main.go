// =================================================================
//
// Copyright (C) 2019 Spatial Current, Inc. - All Rights Reserved
// Released as open source under the MIT License.  See LICENSE file.
//
// =================================================================

package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"

	"github.com/spatialcurrent/go-simple-serializer/pkg/gss"
	"github.com/spatialcurrent/go-simple-serializer/pkg/serializer"
)

const (
	flagFormat   string = "format"
	flagPretty   string = "pretty"
	flagNull     string = "null"
	flagSorted   string = "sorted"
	flagReversed string = "reversed"
)

var (
	validFormats = []string{
		serializer.FormatCSV,        // comma-separated values
		serializer.FormatBSON,       // binary json
		serializer.FormatGo,         // Go-syntax representation of the value
		serializer.FormatGob,        // gob-encoded
		serializer.FormatJSON,       // JSON
		serializer.FormatProperties, // java properties
		serializer.FormatTags,       // list of space-separated key=value pairs
		serializer.FormatTOML,       // TOML - https://github.com/toml-lang/toml
		serializer.FormatTSV,        // tab-separated values
		serializer.FormatYAML,       // YAML
	}
)

type errInvalidFormat struct {
	Value   string
	Formats []string
}

func (e *errInvalidFormat) Error() string {
	return fmt.Sprintf("invalid format %s, expecting one of: %s", e.Value, strings.Join(e.Formats, ","))
}

func initFlags(flag *pflag.FlagSet) {
	flag.StringP(flagFormat, "f", serializer.FormatProperties, "output format, one of: "+strings.Join(validFormats, ", "))
	flag.BoolP(flagPretty, "p", false, "use pretty output format")
	flag.BoolP(flagSorted, "s", false, "sort output")
	flag.BoolP(flagReversed, "r", false, "if output is sorted, sort in reverse alphabetical order")
	flag.BoolP(flagNull, "0", false, "use a NUL byte to end each line instead of a newline character")
}

func initViper(cmd *cobra.Command) (*viper.Viper, error) {
	v := viper.New()
	err := v.BindPFlags(cmd.Flags())
	if err != nil {
		return v, errors.Wrap(err, "error binding flag set to viper")
	}
	v.SetEnvKeyReplacer(strings.NewReplacer("-", "_"))
	v.AutomaticEnv() // set environment variables to overwrite config
	return v, nil
}

func checkConfig(v *viper.Viper) error {
	format := strings.ToLower(v.GetString(flagFormat))
	for _, validFormat := range validFormats {
		if format == validFormat {
			return nil
		}
	}
	return &errInvalidFormat{Value: format, Formats: validFormats}
}

func main() {
	cmd := &cobra.Command{
		Use:                   "goprintenv [-f FORMAT] [flags] [variable]...",
		DisableFlagsInUseLine: true,
		Short:                 "goprintenv",
		Long: `goprintenv is a super simple utility to print environment variables in a custom format.
Supports the following formats: ` + strings.Join(validFormats, ", ") + `.`,
		RunE: func(cmd *cobra.Command, args []string) error {
			v, err := initViper(cmd)
			if err != nil {
				return errors.Wrap(err, "error initializing viper")
			}

			if errConfig := checkConfig(v); errConfig != nil {
				return errConfig
			}

			obj := map[string]string{}
			if len(args) > 0 {
				for _, k := range args {
					obj[k] = os.Getenv(k)
				}
			} else {
				for _, v := range os.Environ() {
					parts := strings.SplitN(v, "=", 2)
					obj[parts[0]] = parts[1]
				}
			}

			format := v.GetString(flagFormat)

			lineSeparator := "\n"
			if v.GetBool(flagNull) {
				lineSeparator = string([]byte{byte(0)})
			}

			sorted := v.GetBool(flagSorted)

			serializeBytesInput := &gss.SerializeBytesInput{
				Object:            obj,
				Format:            format,
				Header:            gss.NoHeader,
				Limit:             gss.NoLimit,
				Pretty:            v.GetBool(flagPretty),
				Sorted:            sorted,
				Reversed:          v.GetBool(flagReversed),
				LineSeparator:     lineSeparator,
				KeyValueSeparator: "=",
				EscapePrefix:      "",
			}

			if !sorted {
				if format == serializer.FormatTags {
					header := make([]interface{}, 0)
					for _, k := range args {
						header = append(header, k)
					}
					serializeBytesInput.Header = header
				}
			}

			outputBytes, err := gss.SerializeBytes(serializeBytesInput)
			if err != nil {
				return err
			}

			switch format {
			case serializer.FormatCSV, serializer.FormatTOML, serializer.FormatTSV, serializer.FormatYAML:
				// do not include trailing new line, since it comes with the output
				fmt.Print(string(outputBytes))
			default:
				// print trailing new line for all others
				fmt.Println(string(outputBytes))
			}

			return nil

		},
	}
	initFlags(cmd.Flags())

	if err := cmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, "goprintenv: "+err.Error())
		fmt.Fprintln(os.Stderr, "Try goprintenv --help for more information.")
		os.Exit(1)
	}
}
