#!/bin/bash

echo "Applying migration ContactDetails"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /contactDetails                        controllers.ContactDetailsController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /contactDetails                        controllers.ContactDetailsController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeContactDetails                  controllers.ContactDetailsController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeContactDetails                  controllers.ContactDetailsController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "contactDetails.title = contactDetails" >> ../conf/messages.en
echo "contactDetails.heading = contactDetails" >> ../conf/messages.en
echo "contactDetails.field1 = Field 1" >> ../conf/messages.en
echo "contactDetails.field2 = Field 2" >> ../conf/messages.en
echo "contactDetails.checkYourAnswersLabel = contactDetails" >> ../conf/messages.en
echo "contactDetails.error.field1.required = Enter field1" >> ../conf/messages.en
echo "contactDetails.error.field2.required = Enter field2" >> ../conf/messages.en
echo "contactDetails.error.field1.length = field1 must be 100 characters or less" >> ../conf/messages.en
echo "contactDetails.error.field2.length = field2 must be 100 characters or less" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryContactDetailsUserAnswersEntry: Arbitrary[(ContactDetailsPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[ContactDetailsPage.type]";\
    print "        value <- arbitrary[ContactDetails].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryContactDetailsPage: Arbitrary[ContactDetailsPage.type] =";\
    print "    Arbitrary(ContactDetailsPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to ModelGenerators"
awk '/trait ModelGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryContactDetails: Arbitrary[ContactDetails] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        field1 <- arbitrary[String]";\
    print "        field2 <- arbitrary[String]";\
    print "      } yield ContactDetails(field1, field2)";\
    print "    }";\
    next }1' ../test/generators/ModelGenerators.scala > tmp && mv tmp ../test/generators/ModelGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(ContactDetailsPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def contactDetails: Option[AnswerRow] = userAnswers.get(ContactDetailsPage) map {";\
     print "    x => AnswerRow(\"contactDetails.checkYourAnswersLabel\", s\"${x.field1} ${x.field2}\", false, routes.ContactDetailsController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration ContactDetails completed"