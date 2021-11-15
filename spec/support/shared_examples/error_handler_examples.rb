# frozen_string_literal: true

module Bonita::ErrorHandlerExamples
  RSpec.shared_examples "an error handler" do
    described_class.resources.each do |action|
      describe "##{action.name}" do
        context "404 error" do
          let(:connection) do
            build_connection do |stub|
              stub.public_send(action.verb, action.path) { [404, {}, "{}"] }
            end
          end

          it "handles 404 status code" do
            expect { subject.public_send(action.name) }.to raise_error Bonita::RecordNotFoundError
          end
        end
      end
    end
  end
end
