// Copyright (c) 2025 WSO2 LLC (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Defines the common error type for the module.
public type Error distinct error;

# Any error occurred during parsing OpenAPI specification is classified under this error type.
public type OpenApiParsingError distinct Error;

# Stackoverflow errors due to lenthy OpenAPI specification or cyclic references in the specification.
public type ParsingStackOverflowError distinct OpenApiParsingError;

# Errors occurred due to unsupported path parameter serializations.
public type UnsupportedSerializationError distinct OpenApiParsingError;

# Errors due to unsupported OpenAPI specification version.
public type UnsupportedOpenApiVersion distinct OpenApiParsingError;

# Errors due to invalid or broken references in the OpenAPI specification.
public type InvalidReferenceError distinct OpenApiParsingError;

# Errors due to incomplete OpenAPI specification.
public type IncompleteSpecificationError distinct OpenApiParsingError;

# Errors due to unsupported media type.
public type UnsupportedMediaTypeError distinct OpenApiParsingError;

# Error through due to invalid parameter definition that does not include either schema or content.
public type InvalidParameterDefinition distinct OpenApiParsingError;

# Any error occurred during LLM generation is classified under this error type.
public type LlmError distinct Error;

# Errors occurred due to unexpected responses from the LLM.
public type LlmInvalidResponseError distinct LlmError;

# Errors occurred due to invalid LLM generation.
public type LlmInvalidGenerationError distinct LlmError;

# Errors occurred during LLM generation due to connection.
public type LlmConnectionError distinct LlmError;

# Errors occurred due to termination of the Agent's execution.
public type TaskCompletedError distinct Error;

# Errors occurred due while running HTTP service toolkit.
public type HttpServiceToolKitError distinct Error;

# Any error occurred during parsing HTTP response is classified under this error type.
public type HttpResponseParsingError distinct HttpServiceToolKitError;

# Errors during tool execution.
public type ToolExecutionError distinct Error;

# Error during unexpected output by the tool
public type ToolInvalidOutputError distinct ToolExecutionError;

# Errors occurred due to invalid tool name generated by the LLM.
public type ToolNotFoundError distinct LlmInvalidGenerationError;

# Errors occurred due to invalid input to the tool generated by the LLM.
public type ToolInvalidInputError distinct LlmInvalidGenerationError;

# Errors occurred due to missing mandotary path or query parameters.
public type MissingHttpParameterError distinct ToolInvalidInputError;

# Represents an error that occurs when the maximum number of iterations has been exceeded.
public type MaxIterationExceededError distinct (Error & error<record{|(ExecutionResult|ExecutionError)[] steps;|}>);
