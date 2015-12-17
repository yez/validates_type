module ValidatesType
  # Wrapper class for arguments consumed by validates_with
  class Arguments
    # @initialize
    #   param: attribute_name <Symbol> - name of attribute that will be validated
    #   param: attribute_type <Symbol> - type for which to validate the attribute against
    #   param: options <Hash> - extra options to pass along to the validator
    #                           i.e. allow_nil: true, message: 'my custom message'
    #   return: nil
    def initialize(attribute_name, attribute_type, options)
      @attribute_name = attribute_name
      @attribute_type = attribute_type
      @options        = options.is_a?(Hash) ? options : {}
    end

    # format expected by _merge_attributes
    #
    # @to_validation_attributes
    # return: <Array> - cardinality of 2
    def to_validation_attributes
      [attribute_name, merged_options]
    end

    private

    attr_reader :attribute_name, :attribute_type, :options

    # helper method to compact all the options together along
    #   with the type for validation
    #
    # @merged_options
    #   return: <Hash>
    def merged_options
      type.merge(options)
    end

    # helper method to impose the type for validation into an option
    #  that will be merged later
    #
    # @type
    #   return: <Hash>
    def type
      { type: attribute_type }
    end
  end
end
