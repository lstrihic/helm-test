// Copyright 2022 Lovro Strihic <lovrostrihic@hotmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"encoding/binary"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"os"
	"time"
)

var (
	version   = "develop"
	flagDebug = false
)

var rootCmd = &cobra.Command{
	Use:   "",
	Short: "helm-test testing",
	Run: func(cmd *cobra.Command, args []string) {
		log.Info().Interface("flags", args).Send()
		log.Info().Interface("cobra flags", cmd.PersistentFlags()).Send()
		log.Debug().Msg("sample")
		_ = binary.Write(os.Stdout, binary.LittleEndian, "")
	},
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal().Err(err).Send()
	}
}

func init() {
	// init logger
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stderr,
		TimeFormat: time.RFC3339,
	})
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	// init cobra
	cobra.OnInitialize(func() {
		log.Info().Bool("debug", flagDebug).Msg("Level")
		if flagDebug {
			zerolog.SetGlobalLevel(zerolog.DebugLevel)
		}
	})
	rootCmd.PersistentFlags().BoolVar(&flagDebug, "debug", false, "activate debug")
}
