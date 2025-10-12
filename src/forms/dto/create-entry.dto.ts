import { IsISO8601, IsIn, IsObject, IsString, IsUUID } from 'class-validator';

export class CreateFormEntryDto {
  @IsUUID() form_id!: string;
  @IsString() form_name!: string;

  @IsUUID() index_version_id!: string;

  @IsISO8601() filled_at_local!: string;

  @IsIn(['pending', 'synced', 'cancelled'])
  status!: 'pending' | 'synced' | 'cancelled';

  @IsObject() fill_json!: Record<string, any>; // FilledState
  @IsObject() form_json!: Record<string, any>; // FormJSON
}
