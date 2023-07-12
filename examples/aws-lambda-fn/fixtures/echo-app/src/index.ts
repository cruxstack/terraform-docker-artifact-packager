import { APIGatewayProxyEvent, APIGatewayProxyResult, Context } from "aws-lambda";

export const handler = async (event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> => {
  console.log("Event: ", event);

  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
};
