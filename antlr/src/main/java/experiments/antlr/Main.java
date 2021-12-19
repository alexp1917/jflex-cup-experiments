package experiments.antlr;

import org.antlr.v4.runtime.*;
import org.apache.commons.lang3.StringUtils;

import java.util.stream.Stream;


public class Main {
    /**
     * TODO ACTUALLY PARSE TREE NOT VISIT/LISTEN
     */
    public static void main(String[] args) {
        String s = "abc = 1 + 10;";

        CharStream inputStream = CharStreams.fromString(s);
        SimpleLexer simpleLexer = new SimpleLexer(inputStream);
        CommonTokenStream commonTokenStream = new CommonTokenStream(simpleLexer);
        SimpleParser simpleParser = new SimpleParser(commonTokenStream);

        SimpleParser.ParseContext fileContext = simpleParser.parse();
        SimpleVisitor<Integer> visitor = new SimpleBaseVisitor<>() {
            @Override
            protected Integer defaultResult() {
                return 0;
            }

            @Override
            public Integer visitAdditiveExpr(SimpleParser.AdditiveExprContext ctx) {

                Integer integer = getInteger(ctx);
                return integer;
            }

            @Override
            protected Integer aggregateResult(Integer aggregate, Integer nextResult) {
                if (Math.abs(aggregate) > Math.abs(nextResult))
                    return aggregate;
                return nextResult;
            }
        };
        Integer visit = visitor.visit(fileContext);

        // Lexer lexer = new SimpleLexer(inputStream);
        // CommonTokenStream commonTokenStream = new CommonTokenStream(lexer);
        // SimpleParser parser = new SimpleParser(commonTokenStream);
        // SimpleParser.ParseContext parse = parser.parse();

        System.out.println("max is " + visit);
        /*

            {
                // from example
                public static void main( String[] args )
                {
                    CharStream inputStream = CharStreams.fromString(
                        "I would like to [b][i]emphasize[/i][/b] this and [u]underline [b]that[/b][/u] ." +
                        "Let's not forget to quote: [quote author=\"John\"]You're wrong![/quote]");
                    MarkupLexer markupLexer = new MarkupLexer(inputStream);
                    CommonTokenStream commonTokenStream = new CommonTokenStream(markupLexer);
                    MarkupParser markupParser = new MarkupParser(commonTokenStream);
                    MarkupParser.FileContext fileContext = markupParser.file();
                    MarkupVisitor visitor = new MarkupVisitor();
                    visitor.visit(fileContext);
                }
            }
            {
                // changing example
                public static void main( String[] args )
                {
                    CharStream inputStream = CharStreams.fromString(
                        "I would like to [b][i]emphasize[/i][/b] this and [u]underline [b]that[/b][/u] ." +
                        "Let's not forget to quote: [quote author=\"John\"]You're wrong![/quote]");
                    SimpleLexer simpleLexer = new SimpleLexer(inputStream);
                    CommonTokenStream commonTokenStream = new CommonTokenStream(simpleLexer);
                    SimpleParser simpleParser = new SimpleParser(commonTokenStream);
                    // DOES NOT WORK (???)
                    SimpleParser.FileContext fileContext = simpleParser.file();
                    // DOES NOT WORK (???)
                    SimpleVisitor visitor = new SimpleVisitor();
                    visitor.visit(fileContext);
                }
            }
         */
    }

    /**
     * Add or subtract arguments
     *
     * @param ctx generated class representing state of parser during addition
     * @return result of addition or subtraction depending on state
     */
    private static Integer getInteger(SimpleParser.AdditiveExprContext ctx) {
        Stream<Integer> integerStream = ctx.expr().stream()
                .map(RuleContext::getText)
                .filter(StringUtils::isNumeric)
                .map(Integer::valueOf);

        if (ctx.PLUS() != null)
            return integerStream.reduce(0, Integer::sum);

        RuleContext payload = ctx.getPayload();
        Integer a = Integer.valueOf(ctx.expr(0).getText());
        if (ctx.MINUS() != null)
            return integerStream
                    .skip(1)
                    .map(Math::negateExact)
                    .reduce(a, Integer::sum);
        return 0;
    }
}
