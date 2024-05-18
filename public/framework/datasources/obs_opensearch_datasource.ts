/*
 * Copyright OpenSearch Contributors
 * SPDX-License-Identifier: Apache-2.0
 */

import { DataSource } from '../../../../../src/plugins/data/public';

interface DataSourceConfig {
  name: string;
  type: string;
  metadata: any;
}

export class ObservabilityDefaultDataSource extends DataSource<any, any, any, any, any> {
  constructor({ name, type, metadata }: DataSourceConfig) {
    super(name, type, metadata);
  }

  async getDataSet() {
    return { dataSets: ['Default data source'] };
  }

  async testConnection(): Promise<boolean> {
    return true;
  }

  async runQuery() {
    return { data: {} };
  }
}
