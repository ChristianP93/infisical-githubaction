import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  await app.listen(3000);

  console.log('envFile', process.env.CHECK_ENV);

  console.log(
    'ConfigService variable:',
    app.get(ConfigService).get('checkEnv.SECRET'),
  );
}
bootstrap();
