can-i-deploy --pacticipant Foo --latest dev --to staging
can-i-deploy --pacticipant Foo --latest dev --with-all-tagged prod # multiple versions in production

can-i-deploy --pacticipant Foo --stage dev --to-stage prod

can-i-deploy --pacticipant Foo --branch dev --to-stage prod
can-i-deploy --pacticipant Foo --latest dev --to-stage prod
