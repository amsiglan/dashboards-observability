/*
 * Copyright OpenSearch Contributors
 * SPDX-License-Identifier: Apache-2.0
 */

import {
  EuiAccordion,
  EuiBadge,
  EuiCallOut,
  EuiFlexGroup,
  EuiFlexItem,
  EuiIcon,
  EuiLink,
  EuiMarkdownFormat,
  EuiPanel,
  EuiSpacer,
  EuiText,
} from '@elastic/eui';
import React from 'react';
import chatLogo from '../../datasources/icons/query-assistant-logo.svg';

export function QueryAssistSummarization({
  queryAssistantSummarization,
  setNlqInput,
  showFlyout,
}: any) {
  return (
    <EuiPanel>
      <EuiAccordion
        id="summarization-accordion"
        buttonContent="AI Insights"
        initialIsOpen
        isLoading={queryAssistantSummarization?.summaryLoading ?? false}
        isLoadingMessage="Loading summary.."
        extraAction={
          <EuiFlexGroup direction="row" alignItems="center" gutterSize="s">
            <EuiFlexItem grow={false}>
              <EuiText color="subdued">
                <small>Generated by Opensearch Assistant</small>
              </EuiText>
            </EuiFlexItem>
            <EuiFlexItem grow={false}>
              <EuiIcon type={chatLogo} size="l" />
            </EuiFlexItem>
          </EuiFlexGroup>
        }
      >
        {queryAssistantSummarization?.summary?.length > 0 && (
          <>
            <EuiSpacer size="m" />
            {queryAssistantSummarization?.isPPLError ? (
              <>
                <EuiCallOut title="There was an error" color="danger" iconType="alert">
                  <EuiMarkdownFormat>{queryAssistantSummarization.summary}</EuiMarkdownFormat>
                </EuiCallOut>
                <EuiSpacer size="s" />
                <EuiFlexGroup wrap gutterSize="s">
                  <EuiFlexItem grow={false}>
                    <EuiText size="s">Suggestions:</EuiText>
                  </EuiFlexItem>
                  {queryAssistantSummarization.suggestedQuestions.map((question) => (
                    <EuiFlexItem grow={false}>
                      <EuiBadge
                        color="hollow"
                        iconType="chatRight"
                        iconSide="left"
                        onClick={() => setNlqInput(question)}
                        onClickAriaLabel="Set input to the suggested question"
                      >
                        {question}
                      </EuiBadge>
                    </EuiFlexItem>
                  ))}
                  <EuiFlexItem grow={false}>
                    <EuiBadge
                      color="hollow"
                      iconType="questionInCircle"
                      iconSide="left"
                      onClick={showFlyout}
                      onClickAriaLabel="Show PPL documentation"
                    >
                      PPL Documentation
                    </EuiBadge>
                  </EuiFlexItem>
                </EuiFlexGroup>
              </>
            ) : (
              <EuiPanel color="subdued" style={{ marginLeft: 16, marginRight: 16 }}>
                <EuiMarkdownFormat>{queryAssistantSummarization.summary}</EuiMarkdownFormat>
              </EuiPanel>
            )}
            <EuiSpacer size="m" />
            <EuiText color="subdued">
              <small>
                The OpenSearch Assistant may produce inaccurate information. Verify all information
                before using it in any environment or workload. Share feedback via{' '}
                <EuiLink href="https://forum.opensearch.org/t/feedback-opensearch-assistant/16741">
                  Forum
                </EuiLink>{' '}
                or{' '}
                <EuiLink href="https://opensearch.slack.com/channels/assistant-feedback">
                  Slack
                </EuiLink>
              </small>
            </EuiText>
          </>
        )}
      </EuiAccordion>
    </EuiPanel>
  );
}
