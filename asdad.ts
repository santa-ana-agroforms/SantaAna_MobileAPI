interface Field {
  id_field: string;
  type: 'string' | 'number' | 'boolean' | 'date' | 'hour' | 'group' | 'img';
  label: string;
  intern_name: string;
  required: boolean;
  sequence: number;
  class:
    | 'text'
    | 'number'
    | 'boolean'
    | 'string'
    | 'date'
    | 'hour'
    | 'group'
    | 'firm'
    | 'dataset'
    | 'list'
    | 'calc';
  config: {
    [key: string]: any;
  };
}

interface Number {
  min: number;
  max: number;
  step: number;
  unit?: '$' | '€' | '£' | 'Q';
}

interface Group {
  id_group: string;
  name: string;
  fieldCondition: string;
}

interface Dataset {
  file: string;
  column: string;
}

interface List<T extends string | number | boolean> {
  id_list: string;
  items: T[];
}

interface Calc {
  vars: string[];
  operation: string;
}
