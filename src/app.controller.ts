import { Controller, Get, Header } from '@nestjs/common';
import { AppService } from './app.service';

const PROBELY_VERIFY_FILENAME = '5b48ed7e-6171-4525-812b-b02d633ae2e3.txt';

const PROBELY_VERIFY_CONTENT = 'Probely';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('health')
  healthCheck(): string {
    return 'OK';
  }

  @Get(PROBELY_VERIFY_FILENAME)
  @Header('Content-Type', 'text/plain')
  probelyVerify(): string {
    return PROBELY_VERIFY_CONTENT;
  }
}
