import { HashEncodeService } from './hashEncode.service';
export declare class HashEncodeController {
    private readonly hashEncodeService;
    constructor(hashEncodeService: HashEncodeService);
    findAll(): string;
}
