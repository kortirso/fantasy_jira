export const componentTypes = ['Tasks'] as const;

export type ComponentType = typeof componentTypes[number];

export interface Attribute {
  attributes: any;
}

export type KeyValue = {
  [key in string]: string;
};

export interface Task {
  id: number;
  name: string;
  state: string;
}

export interface TaskInput {
  id?: number;
  state?: string;
}
